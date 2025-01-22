#!/bin/bash

STACK_NAME="aws-budget-monitor"
TEMPLATE_FILE="config/budget.yaml"
REGION="us-west-2"  # Specify your region here

# Check if stack exists
STACK_EXISTS=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION 2>&1)

if [ $? -eq 0 ]; then
  echo "Stack exists. Deleting stack..."
  aws cloudformation delete-stack --stack-name $STACK_NAME --region $REGION

  # Wait for the stack to be deleted
  echo "Waiting for stack deletion to complete..."
  aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME --region $REGION
fi

echo "Creating stack..."
aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://$TEMPLATE_FILE --capabilities CAPABILITY_NAMED_IAM --region $REGION

# Wait for the stack creation to complete
aws cloudformation wait stack-create-complete --stack-name $STACK_NAME --region $REGION

echo "Stack operation complete."