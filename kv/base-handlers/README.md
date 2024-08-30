# KV Base Handlers
Installs set and get handlers.

# Install
1. make sure you have APM and "@aopermawebpackages/kv-base" installed.
2. APM.install("@aopermawebpackages/kv-base-handlers")

# Usage
## Get
Will get a value given a Kv-Key and Kv-Store-Name

Params:
- Action: aop.Kv-Get
- Key Tag: Kv-Key
- Store Name Tag: Kv-Store-Name

### Returns On Success

Action: "aop.Kv-Get-Success"

Data: stringified json:
```
{
  KV_KEY = kv_key,
  KV_VALUE = kv_value,
  KV_NAME = kv_store_name
}
```

### Returns On Not Found

Action: "aop.Kv-Get-Not-Found"

Data: stringified json:
```
{
  KV_KEY = kv_key,
  KV_VALUE = nil,
  KV_NAME = kv_store_name
}
```

### Send Example for Get

```
Send({Target = ao.id, Tags = { Action = "aop.Kv-Get", Kv-Key = "Hat", Kv-Store-Name="SomeStore" },  Data = "{}" })
```
## Set

Will Set a key value pair in a named store, creating that store if necessary.
- Action: aop.Kv-Get
- Key Tag: Kv-Key
- Value Tag: Kv-Value
- Store Name Tag: Kv-Store-Name

### Returns On Success

Action: "aop.Kv-Set-Success"

Data: stringified json:
```
{
  KV_KEY = kv_key,
  KV_VALUE = kv_value,
  KV_NAME = kv_store_name
}
```

### Send Example for Set
```
Send({Target = ao.id, Tags = { Action = "aop.Kv-Set", Kv-Key = "Hat", Kv-Value = "Kv-Store-Name = "SomeStore" },  Data = "{}" })
```

# Contribute

1. cd into this directory `ao-permaweb-packages/kv/base-handlers`
2. Make changes to `src/handlers.lua`
3. Run `./build.sh`
4. Publish `dist/main.lua`