run-name: "Security_Catalog Deployment"
on:
  workflow_dispatch:
    inputs:
      destroy:
        description: 'Whether to destroy the infra components'
        default: false
        required: false
        type: boolean
      region:
        description: 'Which region would want to deploy to'
        default: 'ap-south-1'
        required: false
        type: string
      bucket_name:
        description: 'The name of the S3 bucket to check tags'
        required: true
        type: string
  push:
    branches:
      - main
      - scp

defaults:
  run:
    shell: bash
    working-directory: ./
jobs:
  terraform-create:
    if: ${{ github.event.inputs.destroy == 'false' }}
    runs-on: ubuntu-latest
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_KEY }}
      AWS_DEFAULT_REGION: ${{ github.event.inputs.region }}
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Set up AWS Creds
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ env.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ env.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_DEFAULT_REGION }}
      - name: Install OPA
        run: |
          echo "** Installing OPA **"
          curl -L -o opa https://openpolicyagent.org/downloads/v0.43.1/opa_linux_amd64
          chmod +x opa
          sudo mv opa /usr/local/bin/
      - name: Install dependencies
        uses: hashicorp/setup-terraform@v2
      - name: Terraform Init
        run: |
          echo `pwd`
          echo "** Running Terraform Init**"
          terraform init -upgrade
          echo "** Terraform Version**"
          terraform -v
          echo "** Running Terraform Validate**"
          terraform validate
      - name: Terraform Plan
        id: terraform_plan
        run: |
          echo "** Running Terraform Plan**"
          terraform plan -out=./tfplan
          terraform show -json ./tfplan > tfplan.json

      - name: OPA Policy Check
        run: |
          echo "** Running OPA Policy Check **"
          opa eval --data your_policy.rego --input tfplan.json "data.s3_bucket.allow" | tee result.json
          if grep -q 'false' result.json; then
            echo "Policy check failed: Denied by OPA policy"
            exit 1
          fi

      - name: Terraform Apply
        run: |
          echo "** Running Terraform Apply**"
          terraform apply -auto-approve ./tfplan
      - name: Check S3 Bucket Tags
        run: |
          echo "** Checking S3 Bucket Tags **"
          aws s3api get-bucket-tagging --bucket ${{ github.event.inputs.bucket_name }} || echo "Bucket does not exist or has no tags"

  terraform-destroy:
    if: ${{ github.event.inputs.destroy == 'true' }}
    runs-on: ubuntu-latest
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_KEY }}
      AWS_DEFAULT_REGION: ${{ github.event.inputs.region }}
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Set up AWS Creds
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ env.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ env.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_DEFAULT_REGION }}
      - name: Install OPA
        run: |
          echo "** Installing OPA **"
          curl -L -o opa https://openpolicyagent.org/downloads/v0.43.1/opa_linux_amd64
          chmod +x opa
          sudo mv opa /usr/local/bin/
      - name: Install dependencies
        uses: hashicorp/setup-terraform@v2
      - name: Terraform Init
        run: |
          echo `pwd`
          echo "** Running Terraform Init**"
          terraform init -upgrade
          echo "** Terraform Version**"
          terraform -v
          echo "** Running Terraform Validate**"
          terraform validate
      - name: Terraform Plan
        id: terraform_destroy_plan
        run: |
          echo "** Running Terraform Plan (Destroy)**"
          terraform plan -destroy -out=./tfplan
          terraform show -json ./tfplan > tfplan.json

      - name: OPA Policy Check
        run: |
          echo "** Running OPA Policy Check (Destroy)**"
          opa eval --data your_policy.rego --input tfplan.json "data.s3_bucket.allow" | tee result.json
          if grep -q 'false' result.json; then
            echo "Policy check failed: Denied by OPA policy"
            exit 1
          fi

      - name: Terraform Apply
        run: |
          echo "** Running Terraform Apply**"
          terraform apply -auto-approve ./tfplan
