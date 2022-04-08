#pragma once

#include <filesystem>
#include <string>
#include <map>
#include <optional>

#include <Poco/Timestamp.h>
#include <Core/Defines.h>
#include <Common/Exception.h>
#include <IO/ReadSettings.h>
#include <IO/WriteSettings.h>



namespace DB
{

class ReadBufferFromFileBase;
class WriteBufferFromFileBase;


using ObjectAttributes = std::map<std::string, std::string>;

struct ObjectMetadata
{
    uint64_t size_bytes;
    std::optional<Poco::Timestamp> last_modified;
    std::optional<ObjectAttributes> attribtues;
};

enum class WriteMode
{
    Rewrite,
    Append
};

class IObjectStorage
{
public:
    virtual bool exists(const std::string & path) const = 0;
    virtual void listPrefix(const std::string & path, std::vector<std::string> & children) const = 0;

    virtual ObjectMetadata getObjectMetadata(const std::string & path) const = 0;

    /// Open the file for read and return ReadBufferFromFileBase object.
    virtual std::unique_ptr<ReadBufferFromFileBase> readObject( /// NOLINT
        const std::string & path,
        const ReadSettings & settings = ReadSettings{},
        std::optional<size_t> read_hint = {},
        std::optional<size_t> file_size = {}) const = 0;

    /// Open the file for write and return WriteBufferFromFileBase object.
    virtual std::unique_ptr<WriteBufferFromFileBase> writeObject( /// NOLINT
        const std::string & path,
        std::optional<ObjectAttributes> attributes = {},
        size_t buf_size = DBMS_DEFAULT_BUFFER_SIZE,
        WriteMode mode = WriteMode::Rewrite,
        const WriteSettings & settings = {}) = 0;

    /// Remove file. Throws exception if file doesn't exists or it's a directory.
    virtual void removeObject(const std::string & path) = 0;

    virtual void removeObjects(const std::vector<std::string> & paths) = 0;

    /// Remove file if it exists.
    virtual void removeObjectIfExists(const std::string & path) = 0;

    virtual ~IObjectStorage() = default;
};

}