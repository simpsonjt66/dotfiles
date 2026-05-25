# Dotfiles Symlink Manager - Design Document

## 1. Overview

### Purpose
Automate the management of dotfiles by creating and maintaining symlinks from a git repository to their target locations in the user's home directory and system.

### Goals
- Automatically create symlinks for dotfiles from a repository to target locations
- Detect and handle existing files/symlinks at target locations
- Provide safe, idempotent operations
- Support easy rollback and verification

## 2. Architecture

### Configuration File Format
The application should read a configuration file (e.g., `dotfiles.yaml` or `dotfiles.json`) that maps source files to target locations.

**Example structure:**
```yaml
dotfiles:
  - source: .config/nvim/init.vim
    target: ~/.config/nvim/init.vim
  - source: .bashrc
    target: ~/.bashrc
  - source: .config/i3/config
    target: ~/.config/i3/config
```

### Command Structure
```
dotfiles-manager [command] [options]

Commands:
  install     Create all symlinks defined in config
  verify      Check if all symlinks are correctly configured
  uninstall   Remove all managed symlinks
  status      Show current state of all managed symlinks
  add         Add a new dotfile to management (move file to repo, create symlink)
```

## 3. Core Functionality

### 3.1 Symlink Creation Process
1. Read configuration file
2. For each entry:
   - Resolve source path (relative to repository root)
   - Resolve target path (expand ~ and environment variables)
   - Check if target exists
   - Handle according to target state (see section 4)
   - Create parent directories if needed
   - Create symlink

### 3.2 State Detection
For each target location, detect:
- **Does not exist**: Safe to create symlink
- **Is a symlink pointing to correct source**: Already configured (skip)
- **Is a symlink pointing elsewhere**: Conflict (requires user decision)
- **Is a regular file**: Potential conflict (requires backup/user decision)
- **Is a directory**: Conflict (special handling needed)

## 4. Edge Cases and Handling

### 4.1 Existing Files at Target Location
**Scenario**: Target path exists as a regular file

**Options**:
- `--backup`: Move existing file to `<filename>.backup.<timestamp>`
- `--force`: Overwrite/remove existing file
- `--skip`: Skip this symlink and continue
- `--interactive`: Prompt user for each conflict

**Default behavior**: Fail-safe (report error, don't modify)

### 4.2 Existing Symlinks (Wrong Target)
**Scenario**: Symlink exists but points to different location

**Options**:
- Report as warning
- `--force`: Update symlink to correct target
- `--fix`: Update only symlinks pointing to non-existent targets

### 4.3 Missing Parent Directories
**Scenario**: `~/.config/nvim/init.vim` but `~/.config/nvim/` doesn't exist

**Handling**:
- Create parent directories automatically with `mkdir -p`
- Use sensible permissions (755 for directories)
- Log directory creation

### 4.4 Circular Symlinks
**Scenario**: Source file is itself a symlink creating circular reference

**Handling**:
- Detect circular references before creation
- Warn user and skip
- Optionally resolve to real path

### 4.5 Permission Issues
**Scenario**: No write permission in target directory

**Handling**:
- Detect permission issues before attempting operation
- Provide clear error message
- Optionally suggest `sudo` for system-wide dotfiles

### 4.6 Repository Not Clean
**Scenario**: Git repository has uncommitted changes

**Options**:
- `--check-git`: Verify repository is clean before operations
- Warn if repository is dirty
- Optionally refuse to operate on dirty repository

### 4.7 Broken Symlinks
**Scenario**: Existing symlink points to non-existent location

**Handling**:
- Detect and report broken symlinks
- `--fix`: Remove broken symlinks and recreate
- `--cleanup`: Remove all broken symlinks

### 4.8 Cross-Device Symlinks
**Scenario**: Trying to symlink across filesystems

**Handling**:
- Detect and warn (symlinks work across devices but some tools may complain)
- Document limitations

### 4.9 Dotfiles in Subdirectories
**Scenario**: `.config/nvim/lua/plugins.lua` - deeply nested structure

**Handling**:
- Support arbitrary nesting depth
- Create all necessary parent directories
- Maintain directory structure

## 5. Safety Features

### 5.1 Dry Run Mode
- `--dry-run`: Show what would be done without making changes
- Essential for testing configuration

### 5.2 Backup System
- Automatic backup before replacing existing files
- Backup location: `~/.dotfiles-backups/<timestamp>/`
- `--restore <timestamp>`: Restore from backup

### 5.3 Verification
- Verify symlinks point to expected locations
- Check source files exist in repository
- Detect broken symlinks
- Report mismatches

### 5.4 Logging
- Log all operations to file
- Include timestamps and actions taken
- Log file location: `~/.config/dotfiles-manager/operations.log`

## 6. Configuration File Details

### 6.1 Required Fields
- `source`: Path relative to repository root
- `target`: Absolute path or path with ~ expansion

### 6.2 Optional Fields
- `condition`: Only create symlink if condition is met (e.g., "os == 'linux'")
- `priority`: Order of operations (for dependencies)
- `create_dirs`: Override global setting for directory creation

### 6.3 Global Settings
```yaml
settings:
  repository_root: ~/dotfiles
  backup_dir: ~/.dotfiles-backups
  log_file: ~/.config/dotfiles-manager/operations.log
  default_behavior: backup  # backup, skip, fail, force
```

## 7. Implementation Considerations

### 7.1 Language Choice
- **Bash/Shell**: Simple, native, but limited error handling
- **Python**: Good cross-platform support, rich libraries
- **Rust/Go**: Better performance, static binaries
- **Recommendation**: Python for balance of simplicity and robustness

### 7.2 Dependencies
- Minimal external dependencies
- Use standard library where possible
- Optional: YAML/JSON parsing library

### 7.3 Testing Strategy
- Unit tests for path resolution
- Integration tests for symlink operations
- Test in isolated environment (Docker/VM)
- Test all edge cases documented above

## 8. User Workflow

### Initial Setup
```bash
cd ~/dotfiles
dotfiles-manager init  # Create initial config from existing files
dotfiles-manager install --dry-run  # Preview changes
dotfiles-manager install --backup  # Execute with backups
```

### New System Setup
```bash
git clone <repo> ~/dotfiles
cd ~/dotfiles
dotfiles-manager install
```

### Adding New Dotfile
```bash
dotfiles-manager add ~/.vimrc  # Moves file to repo, creates symlink
```

### Verification
```bash
dotfiles-manager status  # Check current state
dotfiles-manager verify  # Verify all links correct
```

## 9. Future Enhancements

- Template system for host-specific configurations
- Encryption support for sensitive dotfiles
- Hook system (pre/post install scripts)
- Integration with package managers (track required packages)
- GUI/TUI interface for management
- Automatic detection of common dotfiles

## 10. Questions to Consider

1. Should the tool support absolute paths in source (outside repository)?
2. How to handle dotfiles that must be different per-host?
3. Should there be support for "includes" (one dotfile sourcing another)?
4. What's the desired behavior for system-wide dotfiles requiring sudo?
5. Should the tool integrate with git operations (auto-commit on changes)?
6. How to handle dotfiles that are generated/compiled from sources?
7. Support for Windows dotfiles (different conventions)?