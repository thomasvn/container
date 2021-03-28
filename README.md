## Walkthrough
```bash
# Create and enter the VM environment
vagrant up
vagrant ssh
```

```bash
# Once inside the VM, use the Makefile to manage the container!
cd /vagrant

# Let's create a namespace for our own process
ps aux
make start
ps aux

# Note, although our process is in a new namespace, we are still within the old user and network namespace. See results from below:
cat /etc/passwd
ifconfig
```


## References
- https://jvns.ca/blog/2016/10/10/what-even-is-a-container/
