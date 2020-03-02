#![deny(clippy::all)]
#![deny(clippy::pedantic)]

#[macro_use]
extern crate log;

use futures::StreamExt;
use kube::{
    api::{v1Event, Api, WatchEvent},
    client::APIClient,
    config,
    runtime::Informer,
};
use prometheus::{Counter, Encoder, Opts, Registry, TextEncoder};

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    std::env::set_var("RUST_LOG", "info,kube=trace");
    pretty_env_logger::init();

    let counter_opts = Opts::new("test_counter", "test counter help");
    let counter = Counter::with_opts(counter_opts).unwrap();
    // Create a Registry and register Counter.
    let r = Registry::new();
    r.register(Box::new(counter.clone())).unwrap();

    let config = config::load_kube_config().await?;
    let client = APIClient::new(config);

    let events = Api::v1Event(client);
    let ei = Informer::new(events);

    loop {
        let mut events = ei.poll().await?.boxed();

        while let Some(event) = events.next().await {
            counter.inc();

            let event = event?;
            handle_events(event)?;

            let mut buffer = vec![];
            let encoder = TextEncoder::new();
            let metric_families = r.gather();
            encoder.encode(&metric_families, &mut buffer).unwrap();
            println!("{}", String::from_utf8(buffer).unwrap());
        }
    }
}

// This function lets the app handle an event from kube
fn handle_events(ev: WatchEvent<v1Event>) -> anyhow::Result<()> {
    match ev {
        WatchEvent::Added(o) => {
            info!("New Event: {}, {}", o.type_, o.message);
        }
        WatchEvent::Modified(o) => {
            info!("Modified Event: {}", o.reason);
        }
        WatchEvent::Deleted(o) => {
            info!("Deleted Event: {}", o.message);
        }
        WatchEvent::Error(e) => {
            warn!("Error event: {:?}", e);
        }
    }
    Ok(())
}
