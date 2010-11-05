# Throw a current_app, console and db shortcut in your home directory.

dep 'handy utils' do
  requires 'current_app symlink', #DONE
           'console shortcut', #DONE
           'db shortcuts' #DONE
end

dep 'current_app symlink' do #DONE
  met? { var(:symlink).p.exists? }
  meet { shell "ln -s #{var(:rails_root).p} #{var(:symlink).p}" }
end

dep 'console shortcut' do #DONE
  requires 'current_app symlink'
  helper(:shortcut_contents) { %Q{#!/bin/bash
cd current_app && script/console #{var(:rails_env)}
  } }
  helper(:shortcut_file) { "~/console".p }
  met? { shortcut_file.exists? && shortcut_file.executable_real? }
  meet {
    shell "cat > #{shortcut_file}", :input => shortcut_contents
    shell "chmod +x #{shortcut_file}"
  }
end

dep 'db shortcuts' do #DONE
  requires 'current_app symlink' #DONE
  helper(:shortcut_contents) { %Q{#!/bin/bash
cd current_app && script/dbconsole -p #{var(:rails_env)}
  } }
  helper(:shortcut_file) { "~/db".p }
  met? { shortcut_file.exists? && shortcut_file.executable_real? }
  meet {
    shell "cat > #{shortcut_file}", :input => shortcut_contents
    shell "chmod +x #{shortcut_file}"
  }
end