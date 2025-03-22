local Base = require("Base")

local Attachment = Base:extend {
    constructor = function(self, data)
        self.super("constructor", data.id)
        self.filename = data.filename
        self.size = data.size
        self.url = data.url
        self.proxyUrl = data.proxyUrl or data.proxy_url
        self.durationSecs = data.durationSecs or data.duration_secs
        self.waveform = data.waveform
        self:update(data)
    end,
    update = function(self, data)
        self.title = data.title
        self.description = data.description
        self.contentType = data.contentType or data.content_type
        self.height = data.height
        self.width = data.width
        self.ephemeral = data.ephemeral
        self.flags = data.flags
    end
}

return Attachment