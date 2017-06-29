function awscliless() {
  echo "AWScliless usage"
  echo " cfn-list"
  echo " cfn-events [id]"
  echo " cfn-outputs [id]"
  echo " cfn-resources [id]"
  echo " cfn-delete [id]"
  echo " cfn-show [id]"
  echo " cfn-create [id] [template] ..."
  echo " cfn-update [id] [template] ..."
  echo ""
  echo " ec2-list"
  echo " ec2-show [id]"
}

function cfn-list () {
  aws cloudformation describe-stacks --query \
  'Stacks[*].{id:StackName,status:StackStatus,update:LastUpdatedTime,z_reason:StackStatusReason}'
}

function cfn-events () {
  aws cloudformation describe-stack-events --stack-name $1 --query \
  'StackEvents[*].{PhysicalId:LogicalResourceId,Status:ResourceStatus,Reason:ResourceStatusReason,Time:Timestamp}' \
  | less
}

function cfn-outputs () {
  aws cloudformation describe-stacks --stack-name $1 --query \
  'Stacks[*].{id:StackName,status:StackStatus,update:LastUpdatedTime,z_outputs:Outputs}'
}

function cfn-resources () {
  aws cloudformation describe-stack-resources --stack-name $1 --query \
  'StackResources[*].{type:ResourceType,id:LogicalResourceId,physicalId:PhysicalResourceId,status:ResourceStatus}'
}

function cfn-delete () {
  aws cloudformation delete-stack --stack-name $1
}

function cfn-show() {
  cfn-resources $1
  cfn-outputs $1
}

function cfn-create() {
  NAME=$1
  TEMPLATE=$2
  shift 2
  aws cloudformation create-stack \
    --stack-name $NAME \
    --template-body file://${TEMPLATE} \
    --capabilities CAPABILITY_IAM \
    $@
}

function cfn-update() {
  NAME=$1
  TEMPLATE=$2
  shift 2
  aws cloudformation update-stack \
    --stack-name $NAME \
    --template-body file://${TEMPLATE} \
    --capabilities CAPABILITY_IAM \
    $@
}

function ec2-list () {
  aws ec2 describe-instances --query \
    'Reservations[*].Instances[*].{id:InstanceId,state:State.Name,privateip:PrivateIpAddress,publichostname:PublicDnsName}'
}

function ec2-show () {
  aws ec2 describe-instances --instance-id $1
}
