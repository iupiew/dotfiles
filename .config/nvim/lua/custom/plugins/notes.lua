-- lua/custom/plugins/notes.lua

-- Create the notes module
local notes = {}

-- Configuration
notes.config = {
  notes_dir = vim.fn.expand '~/notes',
  done_symbol = '●',
  undone_symbol = '○',
  file_extension = '.md',
  default_title = 'Untitled',
}

-- Create notes directory if it doesn't exist
local function ensure_notes_dir()
  local notes_dir = notes.config.notes_dir
  if vim.fn.isdirectory(notes_dir) == 0 then
    vim.fn.mkdir(notes_dir, 'p')
  end
end

-- Get current date for display
local function get_date_display()
  return os.date '%Y-%m-%d %H:%M'
end

-- Sanitize filename (remove invalid characters)
local function sanitize_filename(filename)
  -- Remove or replace invalid characters
  local sanitized = filename:gsub('[<>:"/\\|?*]', '_')
  sanitized = sanitized:gsub('^%s+', ''):gsub('%s+$', '') -- trim spaces
  -- Convert spaces to hyphens and make lowercase
  sanitized = sanitized:gsub('%s+', '-'):lower()
  if sanitized == '' then
    sanitized = notes.config.default_title
  end
  return sanitized
end

-- Extract title from note content
local function extract_title_from_content()
  -- Look for title in YAML frontmatter
  for i = 1, math.min(10, vim.fn.line '$') do
    local line = vim.fn.getline(i)
    local title_match = line:match '^Title:%s*(.+)$'
    if title_match then
      return title_match
    end
  end
  return notes.config.default_title
end

-- Update filename based on title (only called on manual save)
local function update_filename_from_title()
  local current_file = vim.fn.expand '%:p'

  -- Only update if we're in the notes directory
  if not current_file:find(notes.config.notes_dir, 1, true) then
    return
  end

  -- Only proceed if the buffer is not modified (i.e., we just saved)
  if vim.bo.modified then
    return
  end

  local title = extract_title_from_content()
  if not title or title == '' then
    return
  end

  local sanitized_title = sanitize_filename(title)
  local new_filename = sanitized_title .. notes.config.file_extension
  local new_filepath = notes.config.notes_dir .. '/' .. new_filename

  -- Don't rename if filename would be the same
  if current_file == new_filepath then
    return
  end

  -- Get current filename without extension for comparison
  local current_filename_no_ext = vim.fn.fnamemodify(current_file, ':t:r')

  -- Only rename if the title actually differs from current filename
  if sanitized_title == current_filename_no_ext then
    return
  end

  -- Check if target file already exists
  if vim.fn.filereadable(new_filepath) == 1 then
    vim.notify("File with name '" .. new_filename .. "' already exists!", vim.log.levels.WARN)
    return
  end

  -- Save the current cursor position
  local cursor_pos = vim.fn.getpos '.'

  -- Rename the file
  local success = vim.fn.rename(current_file, new_filepath)
  if success == 0 then
    -- Update the buffer to point to the new file
    vim.cmd('file ' .. vim.fn.fnameescape(new_filepath))
    -- Restore cursor position
    vim.fn.setpos('.', cursor_pos)
    vim.notify('Note renamed to: ' .. new_filename, vim.log.levels.INFO)
  else
    vim.notify('Failed to rename file', vim.log.levels.ERROR)
  end
end

-- Create or open a note file
function notes.create_note(filename)
  ensure_notes_dir()

  if not filename or filename == '' then
    filename = notes.config.default_title
  end

  -- Sanitize and ensure filename has extension
  filename = sanitize_filename(filename)
  if not filename:match('%.' .. notes.config.file_extension:gsub('%.', '') .. '$') then
    filename = filename .. notes.config.file_extension
  end

  local filepath = notes.config.notes_dir .. '/' .. filename

  -- Open the file
  vim.cmd('edit ' .. filepath)

  -- If file is new, add a header WITHOUT the bullet point
  if vim.fn.line '$' == 1 and vim.fn.getline(1) == '' then
    local title = filename:gsub(notes.config.file_extension .. '$', '')
    if title == notes.config.default_title then
      title = notes.config.default_title
    end

    local lines = {
      '---',
      'Title: ' .. title,
      'Date: ' .. get_date_display(),
      '---',
      ' ',
      'Title:', -- Start with a title line
    }

    for i, line in ipairs(lines) do
      if i == 1 then
        vim.fn.setline(1, line)
      else
        vim.fn.append(i - 1, line)
      end
    end

    vim.cmd 'normal! 6G$'
  end
end

-- List all notes
function notes.list_notes()
  ensure_notes_dir()

  local note_files = vim.fn.glob(notes.config.notes_dir .. '/*' .. notes.config.file_extension, false, true)

  if #note_files == 0 then
    print('No notes found in ' .. notes.config.notes_dir)
    return
  end

  -- Create a simple selection interface
  local choices = {}
  for i, note in ipairs(note_files) do
    local basename = vim.fn.fnamemodify(note, ':t')
    table.insert(choices, basename)
  end

  vim.ui.select(choices, {
    prompt = 'Select a note to open:',
  }, function(choice)
    if choice then
      local filepath = notes.config.notes_dir .. '/' .. choice
      vim.cmd('edit ' .. filepath)
    end
  end)
end

-- Toggle done/undone status for current line
function notes.toggle_done()
  local line = vim.fn.getline '.'
  local done_symbol = notes.config.done_symbol
  local undone_symbol = notes.config.undone_symbol

  if line:match('^%s*' .. vim.pesc(undone_symbol)) then
    -- Change undone to done
    local new_line = line:gsub(vim.pesc(undone_symbol), done_symbol, 1)
    vim.fn.setline('.', new_line)
  elseif line:match('^%s*' .. vim.pesc(done_symbol)) then
    -- Change done to undone
    local new_line = line:gsub(vim.pesc(done_symbol), undone_symbol, 1)
    vim.fn.setline('.', new_line)
  else
    -- Add undone symbol to beginning of line
    local indent = line:match '^%s*'
    local content = line:match '^%s*(.*)$'
    if content ~= '' then
      vim.fn.setline('.', indent .. undone_symbol .. ' ' .. content)
    else
      vim.fn.setline('.', indent .. undone_symbol .. ' ')
    end
  end
end

-- Add a new note item
function notes.add_note_item()
  local line_num = vim.fn.line '.'
  vim.fn.append(line_num, notes.config.undone_symbol .. ' ')
  vim.cmd 'normal! j$'
end

-- Find the most recent bullet point and get its indentation
local function find_last_bullet_indentation()
  local current_line = vim.fn.line '.'

  -- Look backwards from current line to find the last bullet point
  for i = current_line, 1, -1 do
    local line = vim.fn.getline(i)
    local bullet_match = line:match('^(%s*)[' .. vim.pesc(notes.config.done_symbol) .. vim.pesc(notes.config.undone_symbol) .. ']')
    if bullet_match then
      return bullet_match
    end
  end

  -- If no bullet found, return single space (default indentation)
  return ' '
end

-- Smart Enter function - creates new item with bullet point matching previous indentation
function notes.smart_enter()
  local line = vim.fn.getline '.'
  local line_num = vim.fn.line '.'

  -- Get the current indentation
  local indent = line:match '^%s*'

  -- Check if current line has a bullet point
  local has_bullet = line:match('^%s*[' .. vim.pesc(notes.config.done_symbol) .. vim.pesc(notes.config.undone_symbol) .. ']')

  if has_bullet then
    -- If current line is empty bullet, remove it and go to normal newline
    local content = line:match('^%s*[' .. vim.pesc(notes.config.done_symbol) .. vim.pesc(notes.config.undone_symbol) .. ']%s*(.*)$')
    if not content or content == '' then
      -- Empty bullet line - remove bullet and stay on current line
      vim.fn.setline('.', '')
      return
    end
    -- If line has bullet and content, create new line with same indentation and bullet
    vim.fn.append(line_num, indent .. notes.config.undone_symbol .. ' ')
    vim.cmd 'normal! j$'
  else
    -- Line doesn't have bullet - check if it ends with colon (title/subtitle)
    local trimmed_line = line:gsub('%s+$', '') -- remove trailing whitespace
    if trimmed_line:match ':$' then
      -- This is a title/subtitle, create indented bullet point
      vim.fn.append(line_num, indent .. ' ' .. notes.config.undone_symbol .. ' ')
      vim.cmd 'normal! j$'
    else
      -- Regular line without bullet, create bullet with last bullet's indentation
      local last_bullet_indent = find_last_bullet_indentation()
      vim.fn.append(line_num, last_bullet_indent .. notes.config.undone_symbol .. ' ')
      vim.cmd 'normal! j$'
    end
  end
end

-- Plain Enter function - creates new line without bullet point and no indentation
function notes.plain_enter()
  local line_num = vim.fn.line '.'
  vim.fn.append(line_num, '') -- No indentation at all
  vim.cmd 'normal! j$'
end

-- Save note
function notes.save_note()
  vim.cmd 'write'
  vim.notify 'Note saved!'
end

-- New note (accessible from anywhere)
function notes.new_note()
  notes.create_note()
end

-- Setup function for configuration
function notes.setup(opts)
  opts = opts or {}
  notes.config = vim.tbl_deep_extend('force', notes.config, opts)

  -- Create user commands
  vim.api.nvim_create_user_command('NotesNew', function(args)
    notes.create_note(args.args)
  end, { nargs = '?' })

  vim.api.nvim_create_user_command('NotesList', function()
    notes.list_notes()
  end, {})

  vim.api.nvim_create_user_command('NotesToggle', function()
    notes.toggle_done()
  end, {})

  vim.api.nvim_create_user_command('NotesAdd', function()
    notes.add_note_item()
  end, {})

  vim.api.nvim_create_user_command('NotesSave', function()
    notes.save_note()
  end, {})

  -- Set up autocommands for notes files
  local notes_group = vim.api.nvim_create_augroup('NotesPlugin', { clear = true })

  -- Setup buffer-local keymaps when entering notes
  vim.api.nvim_create_autocmd('BufEnter', {
    group = notes_group,
    pattern = notes.config.notes_dir .. '/*' .. notes.config.file_extension,
    callback = function()
      -- Set up buffer-local keymaps for notes
      local opts = { buffer = true, noremap = true, silent = true }
      vim.keymap.set('n', '<leader>m', notes.toggle_done, opts)
      vim.keymap.set('n', '<leader>ni', notes.add_note_item, opts)
      vim.keymap.set('n', '<leader>sn', notes.save_note, opts)

      -- Add Enter key mappings for insert mode
      vim.keymap.set('i', '<CR>', notes.smart_enter, opts)
      vim.keymap.set('i', '<S-CR>', notes.plain_enter, opts)
    end,
  })

  -- Only rename file when user manually saves (BufWritePost)
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = notes_group,
    pattern = notes.config.notes_dir .. '/*' .. notes.config.file_extension,
    callback = function()
      -- Use a small delay to ensure the save operation is complete
      vim.defer_fn(function()
        update_filename_from_title()
      end, 100)
    end,
  })
end

-- Store the notes module globally so it can be accessed
_G.notes = notes

-- Return the plugin spec for lazy.nvim
return {
  name = 'notes',
  dir = vim.fn.stdpath 'config',
  config = function()
    notes.setup()
  end,
  cmd = {
    'NotesNew',
    'NotesList',
    'NotesToggle',
    'NotesAdd',
    'NotesSave',
  },
  keys = {
    {
      '<leader>nn',
      function()
        notes.new_note()
      end,
      desc = 'New Note',
    },
    {
      '<leader>nl',
      function()
        notes.list_notes()
      end,
      desc = 'List notes',
    },
  },
}
