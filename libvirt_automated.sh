#!/bin/bash

menu()
{
  clear
  echo "###################################"
  echo "Choose what do you would like to do"
  echo
  echo "1 - Clone"
  echo "2 - Delete"
  echo 
  echo "0 - Exit"
  echo
  echo -e "Type your selection: \c"
  read opc
  case $opc in
    1)  echo "Template Operations"
          templateMenu ;;
    2)  echo "VM Operations"
          vmMenu ;;
    0)  echo "Exit"
        exit 1;;
  esac
}


vmMenu()
{

  vmList=$(virsh list --all | grep -v Name | awk '{print $2}')
  echo "##################"
  echo "VM List"
  for b in $vmList
  do
    echo - $b
  done

  echo 
  echo -e "Type the VM name to delete: \c"
  read vmToDelete 

  deleteVM $vmToDelete
}

deleteVM()
{
  echo 
  echo "Deleting VM $1"
  echo -e "Are you sure you would like to delete $1 ?! (Y/N)\c"
  read opc
  case $opc in
    y|Y)  echo "Deleting ...."
          imageFile=$(virsh dumpxml $1 | grep "<source file" | cut -d"'" -f2)
          virsh destroy $1
          virsh undefine $1
          virsh vol-delete $imageFile
          ;;
    n|N)  echo "No"
          ;;
  esac  
}


templateMenu()
{

  templateList=$(virsh list --all | grep template | awk '{print $2}')
  echo "##################"
  echo "Template List"
  for b in $templateList
  do
    echo - $b
  done

  echo 
  echo -e "Type the desired template name: \c"
  read desiredTemplate
  echo -e "Type the new hostname: \c"
  read newHostName
  
  provMachines $desiredTemplate $newHostName
}

provMachines()
{
  tempFile="/tmp/$$"
  echo
  echo "Provision new machine $2"

  # Dumping from template - xml file
  virsh dumpxml $1 > $tempFile
 
  # Clonning the image file
  templateFile=$(grep "source file" $tempFile | cut -d"'" -f2)
  imageDir=$(dirname $templateFile)
  virsh vol-clone --vol $templateFile --newname $2.qcow2

  # Updating the file according options
  sed -i -e "s#<name>.*#<name>$2</name>#g" $tempFile
  sed -i -e "s#<uuid>.*##g" $tempFile
  sed -i -e "s#<source file=.*#<source file='$imageDir/$2.qcow2'/>#g" $tempFile
  sed -i -e "s#<mac address=.*##g" $tempFile
  #sed -i -e "s#<source bridge='BridgeDefault'/>#<source bridge='BridgeDefault'/>#g" $tempFile

  virsh define $tempFile

  # Removing file
  rm -rf $tempFile
}



# Main

menu
