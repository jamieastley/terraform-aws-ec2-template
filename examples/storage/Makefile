TF_PLAN_NAME = tf_plan

module_storage_init:
	terraform init

module_storage_init_upgrade:
	terraform init -upgrade

module_storage_plan:
	op run --env-file="aws.env" -- terraform plan -out=$(TF_PLAN_NAME)

module_storage_apply_plan:
	op run --env-file="aws.env" -- terraform apply $(TF_PLAN_NAME)

module_storage_destroy:
	op run --env-file="aws.env" -- terraform destroy