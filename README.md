Libvirt Automated Script

# Description
This script is just to automate the process to create one new VM and change what is necessary. I'm using here the Libvirt and this script to do
 * Creation of new machine from templates *VM already ready and configured to be one new VM*
 * Deletion of the VMs on the Libvirt, removing everything

#Usage
After download the script, just type
```
# ./autolibvirt.sh
```

After that just follow the script according the menu

```
###################################
Choose what do you would like to do

1 - Clone
2 - Delete

0 - Exit

Type your selection:
```

Here, you will see the templates available in your Libvirt environment, like below

```
Template Operations
##################
Template List
- rhel72_template_NOT-START
- rhel73_sat6.2.8_template_NOT-START
- rhel73_template_NOT-START

Type the desired template name:
```
After select the template name, just type the name of your new VM and press enter

```
Type the desired template name: rhel73_template_NOT-START
Type the new hostname: new01
```

Now there is one new machine totally configured according your template, just turn on and use it.
