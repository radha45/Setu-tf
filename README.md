# Setu-tf

in variables.tf, we have a variable called key_pair, generate a ssh key-pair and pass the public key as a value.

for example, in vars.tfvars, we can add a variable like key_pair="your-ssh-public-key"

we can also change the provider region in providers.tf, instance type and ami in vars.tfvars
