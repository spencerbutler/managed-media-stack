# Functions for [manage](.././manage)


## [L78: get_help](.././manage#L78)

- TODO(spencer) finish writing `get_help`

### Args

- function name (optional): Help on failed function call.

### Returns

- Help for (optional) funcion, or general USAGE.

## [L129: parse_config](.././manage#L129)


### Args

- ITEM: A single item (application name) to parse.
- STACK_ITEMS: A list of `=` delimited lines default: `$STACK_ITEMS`
- 0: Item name (common name of the item)
- 1: Item port (`EXPOSE` port of the item)
- 2: Item provider (linuxserverer,hotio, etc.)
- 3: Item tag (provider version) default: `:latest``
- 4: Enabled (bool)

### Returns

- mapped variables

## [L169: get_items](.././manage#L169)


### Args

- STACK_ITEMS: An array containing a string of `=` delimited lines

### Returns

- ALL_ITEMS: A list of all items.
- ENABLED_ITEMS: A list of all enabled items.
- DISABLED_ITEMS: A list of all disabled items.

## [L202: is_item_enabled](.././manage#L202)


### Args

- ITEM: Test if `ITEM` is enabled.

### Returns

- bool: Is an enabled ITEM.

## [L219: report_items](.././manage#L219)

- TODO(spencer) Prettify the report.

### Arg:

- Query: One of enabled, disabled, or all.

### Returns

- ALL_ITEMS: If Query is all.
- ENABLED_ITEMS: If Query is enabled.
- DISABLED_ITEMS: If Query is disabled.

## [L264: update_template](.././manage#L264)


### Notes

- The TZ and PROVIDER variables contain `/` which
- need to be escaped for `sed`. This is done with 
- bash's variable expansion. It's ugly, but it works.

### Args

- ITEM:  An item (app) to prepare a template for.

### Returns

- ITEM/.env, ITEM/docker-compose: New docker compose
- files, ready to run.

## [L342: item_help](.././manage#L342)

- TODO(spencer) Finish writing `item_help`

### Args

- ITEM: Help for an item.

### Returns

- USAGE: Usage for `$0 ITEM`

## [L364: item_up](.././manage#L364)


### Args

- ITEM: An item (container) to bring up.

### Returns

- None: Executes `docker compose --file FILE up --detach &`.

## [L398: item_down](.././manage#L398)


### Args

- ITEM: An item (container) to bring down.

### Returns

- None: Executes `docker compose --file FILE down &`.

## [L423: item_restart](.././manage#L423)


### Args

- ITEM: An item (container) to restart.

### Returns

- None: Executes `docker compose --file FILE restart &`

## [L448: item_pull](.././manage#L448)


### Args

- ITEM: An item (container) to pull latest image.

### Returns

- None: Executes `docker compose --file FILE pull &`

## [L468: item_inspect](.././manage#L468)


### Args

- ITEM: An item (container) to inspect.

### Returns

- None: Executes `docker inspect ID`.
- None: Warning if trying to to inspect `all` containers.

## [L502: item_status](.././manage#L502)

- TODO(spencer) we use docker ps --all and then check if it's up later

### ARGS

- ITEM: An item to display status for

### Returns

- Status: The status of the ITEM, or all (if the ITEM=all).

## [L591: item_update](.././manage#L591)


### Args

- ITEM: Updates the template for ITEM.

### Returns

- Docker Files: Creates `ITEM/.env` and `ITEM/docker-compose.yaml`
- from the `TEMPLATE/` directory.

## [L612: item_info](.././manage#L612)

- TODO(spencer) Make `item_info` useful, or kill it.

### ARGS

- ITEM: Get info for an item.

### Returns

- Info: Misc information about the item.
