local function pprint(o)
    local result

    local function innerPprint(table)
        if type(table) == 'table' then
            local s = '{ '
            for k, v in pairs(table) do
                if type(k) ~= 'number' then k = '"' .. k .. '"' end
                s = s .. '[' .. k .. '] = ' .. innerPprint(v) .. ','
            end
            return s .. '} '
        else
            return tostring(table)
        end
    end

    result = innerPprint(o)
    print(result)
end

local function fpprint(o)
    local result = ""

    local function innerPprint(table, indent)
        indent = indent or 0
        local s = ""
        local indentStr = string.rep("  ", indent)

        if type(table) == 'table' then
            -- Check if the table is an array
            local isArray = true
            for k, _ in pairs(table) do
                if type(k) ~= 'number' then
                    isArray = false
                    break
                end
            end

            if isArray then
                s = s .. "{"
                for i, v in ipairs(table) do
                    s = s .. innerPprint(v, indent + 1) ..
                            (i < #table and ", " or "")
                end
                s = s .. "}"
            else
                s = s .. "{\n"
                for k, v in pairs(table) do
                    if type(k) ~= 'number' then
                        k = '"' .. k .. '"'
                    end
                    s = s .. indentStr .. "  [" .. k .. "] = " ..
                            innerPprint(v, indent + 1) .. ",\n"
                end
                s = s .. indentStr .. "}"
            end
        else
            return '"' .. tostring(table) .. '"' -- Enclose non-table values in quotes
        end

        return s
    end

    result = innerPprint(o)
    return result
end

return {pprint = pprint, fpprint = fpprint}
