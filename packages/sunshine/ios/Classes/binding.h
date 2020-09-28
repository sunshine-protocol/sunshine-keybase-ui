#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>


/**
 * add a new device to your account
 * the `device` should be in the `ss58` format
 */
int32_t client_device_add(int64_t port, const char *device);

/**
 * Get current Device ID as string (if any)
 * otherwise null returned
 */
int32_t client_device_current(int64_t port);

/**
 * Check if the current client has a device key already or not
 */
int32_t client_device_has_key(int64_t port);

/**
 * get a list of devices that linked to that identifier
 * returns list of devices ids in `ss58` fromat (as strings) or an error message
 */
int32_t client_device_list(int64_t port, const char *identifier);

/**
 * Generate a new backup paper key that can be used to recover your account
 * returns a string that contains the phrase, otherwise null if there is an error
 */
int32_t client_device_paperkey(int64_t port);

/**
 * remove a device from your account
 * the `device` should be in the `ss58` fromat
 */
int32_t client_device_remove(int64_t port, const char *device);

/**
 * Try to mint the current account, this only enabled in testnet and behind a feature flag
 * returned the minted amount or null if there is any errors
 */
int32_t client_faucet_mint(int64_t port);

/**
 * get a list of identities of the provided identifier.
 */
int32_t client_id_list(int64_t port, const char *identifier);

/**
 * prove the current account identity to a service.
 * the service string should be in the format of `username@service` for example `shekohex@github`
 * returns a pair (list of two values) the first element is the `instructions` of how to prove the identity
 * the second element is the `proof` itself where you should follow the instructions and post it somewhere.
 * otherwise and error returned as string.
 */
int32_t client_id_prove(int64_t port,
                        const char *service);

/**
 * Get the `UID` of the provided identifier
 */
int32_t client_id_resolve(int64_t port, const char *identifier);

/**
 * revoke your identity from the provided service
 * see `client_id_prove` for more information.
 * returns `true` if the identity revoked.
 */
int32_t client_id_revoke(int64_t port, const char *service);

/**
 * Setup the Sunshine Client using the provided path as the base path and with chainspec.
 *
 * ### Safety
 * This assumes that the path non-null c string.
 * chain_spec non-null c string.
 */
int32_t client_init(int64_t port, const char *path, const char *chain_spec);

/**
 * Check if the Keystore is exist and initialized.
 *
 * this is useful if you want to check if there is an already created account or not.
 */
int32_t client_key_exists(int64_t port);

/**
 * Lock your account
 * return `true` if locked, and return an error message if something went wrong
 */
int32_t client_key_lock(int64_t port);

/**
 * Set a new Key for this device if not already exist.
 * you should call `client_has_device_key` first to see if you have already a key.
 *
 * suri is used for testing only.
 * phrase is used to restore a backup
 * returns a string that is the current device id
 */
int32_t client_key_set(int64_t port, const char *password, const char *suri, const char *paperkey);

/**
 * Get current UID as string (if any)
 * otherwise null returned
 */
int32_t client_key_uid(int64_t port);

/**
 * Unlock your account using the password
 * return `true` when the account get unlocked, otherwise an error message returned
 */
int32_t client_key_unlock(int64_t port, const char *password);

/**
 * Get the balance of an identifier.
 * returns and string but normally it's a `u128` encoded as string.
 */
int32_t client_wallet_balance(int64_t port, const char *identifier);

/**
 * Transfer tokens to another account using there `identifier`
 * returns current account balance after the transaction.
 */
int32_t client_wallet_transfer(int64_t port, const char *to, uint64_t amount);

/**
 * Check if the Logger is already initialized to prevent any errors of calling init again.
 * return 1 if initialized before, 0 otherwise.
 */
int32_t frusty_logger_is_initialized(void);

/**
 * a hack to make iOS link to this lib
 * no need to call it from the FFI.
 */
void link_me_please(void);
