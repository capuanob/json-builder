#include <stdint.h>
#include "json_builder.h"

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    // Create a JSON array out of fuzzer data
    json_value *arr = json_array_new(size);
    json_array_push(arr, json_string_new_length((unsigned int) size, data);

    // Create a buffer for serialization and serialize
    char *buf = (char*) malloc(json_measure(arr));
    json_serialize(buf, arr);

    // Cleanup
    json_builder_free(arr);
    free(buf);
    return 0;
}
