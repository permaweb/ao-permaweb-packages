#Profile Package

## Testing

### AOS CLI

```
.load path/to/bundle.lua
.editor
<editor mode> use '.done' to submit or '.cancel' to cancel
local P = require("@permaweb/profile")
P.profileKV:set("tree", "green")
print(P.profileKV:get("boots"))
.done
RETURNS:
black

```

### AO LINK
#### Write

```
{
  "process": <your-process>,
  "data": "{\"entries\": [{\"key\": \"hat\", \"value\": \"blue\"}, {\"key\": \"boots\", \"value\": \"black\"}]}",
  "tags": [
    {
      "name": "Action",
      "value": "Profile-Set"
    }
  ]
}
```

#### Read

INPUT
```
{
  "process": <your process>,
  "data": "{\"keys\": [\"hat\", \"boots\"]}",
  "tags": [
    {
      "name": "Action",
      "value": "Profile-Get"
    }
  ]
}
```
OUTPUT
```
    "Data": {
    "Results": {
      "boots": "black",
      "hat": "blue"
    }
    },
```
