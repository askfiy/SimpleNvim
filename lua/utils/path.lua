local path = {}

function path.join(...)
    return table.concat(vim.iter({ ... }):flatten():totable(), "/")
end

function path.exists(p)
    if vim.fn.isdirectory(p) == 1 then
        return true
    end

    return vim.fn.filereadable(p) == 1
end

function path.listdir(p)
    return vim.fn.globpath(p, "*", false, true)
end

function path.filepath()
    return debug.getinfo(2, "S").source:sub(2)
end

function path.dirname(p)
    return vim.fn.fnamemodify(p, ":h")
end


return path
