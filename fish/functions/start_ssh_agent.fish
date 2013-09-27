function start_ssh_agent
    setenv SSH_ENV $HOME/.ssh/environment
    ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
    chmod 600 $SSH_ENV
    . $SSH_ENV > /dev/null
    ssh-add
end
