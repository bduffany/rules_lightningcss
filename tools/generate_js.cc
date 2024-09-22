#include <iostream>
#include <fstream>
#include <string>
#include <unordered_map>
#include <cctype>
#include <cstring>
#include <cerrno>

extern "C" {
    #include "third_party/yyjson/yyjson.h"
}

// Function to convert dashed-string to camelCase
std::string toCamelCase(const std::string& str) {
    std::string result;
    bool capitalizeNext = false;
    for (char ch : str) {
        if (ch == '-') {
            capitalizeNext = true;
        } else if (capitalizeNext) {
            result += std::toupper(ch);
            capitalizeNext = false;
        } else {
            result += ch;
        }
    }
    return result;
}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: program <input_path> <output_path>\n";
        return 1;
    }

    std::string input_path = argv[1];
    std::string output_path = argv[2];

    // Read the entire input file into a string
    std::ifstream input_file(input_path);
    if (!input_file) {
        std::cerr << "Failed to open input file " << input_path << ": " << strerror(errno) << std::endl;
        return 1;
    }

    std::string json_content;
    try {
      input_file.exceptions(std::ifstream::badbit);
      json_content = std::string(
        std::istreambuf_iterator<char>(input_file),
        std::istreambuf_iterator<char>()
      );
    } catch (const std::ios_base::failure& e) {
      std::cerr << "Failed to read file " << input_path << ": " << e.what() << std::endl;
      return 1;
    }
    input_file.close();

    // Parse JSON using yyjson
    yyjson_doc* doc = yyjson_read(json_content.c_str(), json_content.size(), 0);
    if (!doc) {
        std::cerr << "Failed to parse JSON\n";
        return 1;
    }

    yyjson_val* root = yyjson_doc_get_root(doc);
    if (!yyjson_is_obj(root)) {
        std::cerr << "Root is not a JSON object\n";
        yyjson_doc_free(doc);
        return 1;
    }

    // Prepare to store mappings
    std::unordered_map<std::string, std::string> mappings;

    // Iterate over the keys in the JSON object
    yyjson_val* key, *val;
    size_t idx, max;
    yyjson_obj_foreach(root, idx, max, key, val) {
        const char* key_str = yyjson_get_str(key);
        std::string camelCaseKey = toCamelCase(key_str);

        yyjson_val* name_val = yyjson_obj_get(val, "name");
        if (!name_val || !yyjson_is_str(name_val)) {
            std::cerr << "Missing or invalid 'name' field for key: " << key_str << "\n";
            yyjson_doc_free(doc);
            return 1;
        }
        const char* name_str = yyjson_get_str(name_val);

        mappings[camelCaseKey] = name_str;
    }

    yyjson_doc_free(doc);

    // Write the output JS file
    std::ofstream output_file(output_path);
    if (!output_file.is_open()) {
        std::cerr << "Failed to open output file: " << output_path << "\n";
        return 1;
    }

    output_file << "export default {\n";
    for (const auto& pair : mappings) {
        output_file << "  " << pair.first << ": \"" << pair.second << "\",\n";
    }
    output_file << "}\n";

    output_file.close();

    return 0;
}
