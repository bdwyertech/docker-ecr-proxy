-- Encoding: UTF-8
-- AWS ECR Proxy
-- Brian Dwyer - Intelligent Digital Services

local cjson = require "cjson"

local function getToken()
    -- Check for Cached Token
    local ecrToken, flags = ngx.shared.ecr_tokens:get(ngx.var.aws_account or "default")
    if ecrToken then
        return ecrToken
    end
    -- Retrieve a Fresh Token
    local shell = require("resty.shell")
    local cmdString = "/usr/local/bin/ecr-login"
    if ngx.var.aws_account then
        cmdString = cmdString .. string.format(" -account %s", ngx.var.aws_account)
    end
    local ok, stdout, stderr, reason, status = shell.run(cmdString)
    if ok then
        local ecrToken = stdout
        local ecrTokenTimeoutSeconds = 3600
        local succ, err, forcible = ngx.shared.ecr_tokens:set(ngx.var.aws_account or "default", ecrToken, ecrTokenTimeoutSeconds)
        if err then
            ngx.log(ngx.ERR, err)
        end
        return ecrToken
    else
        ngx.log(ngx.ERR, stderr)
    end
end

local ecrToken = getToken()
if ecrToken then
    -- DEBUG
    -- ngx.header.content_type = "text/plain"
    -- ngx.say(ecrToken)
    ngx.req.set_header("Authorization", string.format("Basic %s", ecrToken))
else
    ngx.header.content_type = "application/json; charset=utf-8"
    ngx.status = ngx.HTTP_NOT_FOUND
    -- Build Docker-Compatible Error Response
    resp = {
        errors = {
            {
                code = "NAME_UNKNOWN",
                message = "Proxy server has encountered an error retrieving ECR token."
            }
        }
    }
    ngx.say(cjson.encode(resp))
end
