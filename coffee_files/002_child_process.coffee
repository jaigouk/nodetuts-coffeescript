# # Child Process  
#***   
# * [Node API doc - Child Processes](http://nodejs.org/docs/v0.4.9/api/child_processes.html)
#***   
# ### ChildProcess
#  Node provides a tri-directional popen(3) facility through the ChildProcess class.
# It is possible to stream data through the child's stdin, stdout, and stderr in a fully non-blocking way. 
# To create a child process use require('child_process').spawn(). 
# Child processes always have three streams associated with them. child.stdin, child.stdout, and child.stderr.
# 
# ChildProcess is an EventEmitter.

http = require 'http'
{spawn} = require 'child_process'

server = http.createServer (req, res) ->
  res.writeHead 200,
    'Content-Type': 'text/plain'

# ### spawn
# Launches a new process with the given command, with command line arguments in args. If omitted, args defaults to an empty Array.
  tail_child = spawn 'tail' , ['-f', '/var/log/system.log'] 

# ### child.kill(signal='SIGTERM')
#
# Send a signal to the child process. If no argument is given, the process will be sent 'SIGTERM'. See signal(7) for a list of available signals.   
# **Note that while the function is called kill, the signal delivered to the child process may not actually kill it. kill really just sends a signal to a process.**
  req.connection.on 'end', ->
    tail_child.kill()
  
  tail_child.stdout.on 'data', (data) ->
    console.log data.toString()  
    # This res.write line may cause a problem
    res.write data
  
server.listen 4000
