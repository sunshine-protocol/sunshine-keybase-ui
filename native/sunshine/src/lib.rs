use client::Client;
use frusty_logger::{Config, FilterBuilder};
use log::Level;

frusty_logger::include_ffi!(
  with_config: Config::new(
    Level::Debug,
    FilterBuilder::new()
    .parse(&[
      "sunshine",
      "sc_information",
      "substrate",
      "substrate_subxt",
      "sunshine-identity-ffi",
      "sunshine-faucet-ffi",
      ].join(",")
    )
    .build()
  )
);

keybase_ffi::impl_ffi!(client: Client);
faucet_ffi::impl_ffi!();

/// a hack to make iOS link to this lib
/// no need to call it from the FFI.
#[inline(never)]
#[no_mangle]
pub extern "C" fn link_me_please() {}
