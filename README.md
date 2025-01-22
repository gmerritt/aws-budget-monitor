# AWS Budget Monitor

This project creates and manages an AWS Budget with notifications using AWS CloudFormation.

## Prerequisites

### UCB AWS Access Portal & keys

To access the AWS account, follow these steps:

1. Open the UCB AWS Access Portal at [https://ucberkeley.awsapps.com/start/](https://ucberkeley.awsapps.com/start/).
2. Log in with your UCBerkeley CalNet ID.
3. In the portal, locate and open the turn-down triangle for `eecs-idsg-logs`.
4. Click on "Access keys" and find the appropriate access level for your tasks; click `Access keys`.
5. Choose `Option 1: Set AWS environment variables` and run the quoted `export` command.

### AWS CLI

To install the AWS CLI, follow the instructions for your operating system:

#### Mac

1. Use Homebrew to install the AWS CLI:
   ```bash
   brew install awscli
   ```
2. Verify the installation:
   ```bash
   aws --version
   ```

#### Windows

1. Download the AWS CLI MSI installer from the [official website](https://aws.amazon.com/cli/).
2. Run the installer and follow the on-screen instructions.
3. Verify the installation by opening Command Prompt and running:
   ```cmd
   aws --version
   ```

#### Linux

1. Use the package manager to install the AWS CLI. For example, on Ubuntu:
   ```bash
   sudo apt-get update
   sudo apt-get install awscli
   ```
2. Verify the installation:
   ```bash
   aws --version
   ```

For more detailed instructions, refer to the [AWS CLI installation guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).

## Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/aws-budget-monitor.git
   cd aws-budget-monitor
   ```

## Setting notification levels and recipients

To set notification levels and recipients, you need to modify the `config/budget.yaml` file. Below are the steps to configure the notification settings:

1. Open the `config/budget.yaml` file in your preferred text editor.

2. Locate the `NotificationsWithSubscribers` section. This section defines the notification thresholds and the recipients who will receive the alerts.

3. Modify the `Threshold` values to set the desired notification levels. The `Threshold` is a percentage of the budget limit.

4. Update the `Subscribers` list to include the email addresses of the recipients who should receive the notifications.

You can have multiple `Notification` entries within the `NotificationsWithSubscribers` section. Each `Notification` entry specifies a threshold level and the type of notification. For each `Notification`, you can define multiple email recipients who will receive the alerts. This allows you to set up different notification levels and ensure that the appropriate stakeholders are informed when spending reaches certain percentages of the budget limit.

For example, you might want to notify different sets of recipients when the spending reaches 3%, 15%, 35%, and 70% of the budget. Each `Notification` entry can have its own list of `Subscribers`, and each subscriber can be specified with their email address.

Here is an example configuration:

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
   MonthlyBudget:
      Type: 'AWS::Budgets::Budget'
      Properties:
         Budget:
            BudgetName: 'MonthlyBudget'
            BudgetLimit:
               Amount: 20  # Set your budget limit here
               Unit: 'USD'
            TimeUnit: 'MONTHLY'
            BudgetType: 'COST'
         NotificationsWithSubscribers:
            - Notification:
                  NotificationType: 'ACTUAL'
                  ComparisonOperator: 'GREATER_THAN'
                  Threshold: 3
                  ThresholdType: 'PERCENTAGE'
               Subscribers:
                  - SubscriptionType: 'EMAIL'
                     Address: 'user1@example.com'
                  - SubscriptionType: 'EMAIL'
                     Address: 'user2@example.com'
            - Notification:
                  NotificationType: 'ACTUAL'
                  ComparisonOperator: 'GREATER_THAN'
                  Threshold: 15
                  ThresholdType: 'PERCENTAGE'
               Subscribers:
                  - SubscriptionType: 'EMAIL'
                     Address: 'user1@example.com'
                  - SubscriptionType: 'EMAIL'
                     Address: 'user2@example.com'
            - Notification:
                  NotificationType: 'ACTUAL'
                  ComparisonOperator: 'GREATER_THAN'
                  Threshold: 35
                  ThresholdType: 'PERCENTAGE'
               Subscribers:
                  - SubscriptionType: 'EMAIL'
                     Address: 'user1@example.com'
                  - SubscriptionType: 'EMAIL'
                     Address: 'user2@example.com'
            - Notification:
                  NotificationType: 'ACTUAL'
                  ComparisonOperator: 'GREATER_THAN'
                  Threshold: 70
                  ThresholdType: 'PERCENTAGE'
               Subscribers:
                  - SubscriptionType: 'EMAIL'
                     Address: 'user1@example.com'
                  - SubscriptionType: 'EMAIL'
                     Address: 'user2@example.com'
                  - SubscriptionType: 'EMAIL'
                     Address: 'user3@example.com'
```

Make sure to replace the email addresses with the actual recipients' email addresses and adjust the threshold values as needed.

## Running the Script

To run the script, follow these steps:

1. Ensure you have the necessary AWS credentials configured.
2. Navigate to the project directory:
   ```bash
   cd /path/to/aws-budget-monitor
   ```
3. Execute the script:
   ```bash
   ./scripts/update_budget.sh
   ```

## What the Script Does

The script performs the following actions:

1. Checks if the AWS CloudFormation stack named `aws-budget-monitor` already exists.
   - If the stack exists, it deletes the existing stack and waits for the deletion to complete.
   - *A more typical strategy is to do an update-in-place, but `AWS::Budgets::Budget` seemed to be unhappy to do this for changes to some of the fields.*
2. Creates a new AWS Budget using AWS CloudFormation.
3. Sets up notifications for the budget to alert you when your spending exceeds predefined thresholds.

The deployed [Budget](https://us-east-1.console.aws.amazon.com/billing/home?region=us-west-2#/budgets/overview) monitors your AWS spending and sends notifications based on the configured budget.
