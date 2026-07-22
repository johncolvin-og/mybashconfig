# C Standard Library
* AKA libc
## String Functions
| Name | Copy Count | Returns | Notes |
|------|-------------|------|-----------|
| strcpy(char\* `dst`, const char\* `src`) | strlen(`src`) | char\*: `dst` | Appends null terminator (undefined behavior if `dst` not sufficiently allocated) |
| strncpy(char\* `dst`, const char\* `src`, size_t `n`) | min(`n`, strlen(`src`)) | char\*: `dst` | If strlen(`src`) < `n`, pads remaining bytes with null (otherwise `dst` is ***NOT*** null terminated) |
| strlcpy(char\* `dst`, const char\* `src`, size_t `n`) | min(`n` - 1, strlen(`src`)) | size_t: N chars copied (i.e., strlen(`dst`)) | Appends null terminator (a safer null-terminating version of strncpy) |
| strdup(const char\* `s`) | strlen(`s`) | char\*: newly allocated copy of `s` | Caller responsible for freeing returned string
