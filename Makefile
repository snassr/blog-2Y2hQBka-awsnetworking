tf-fmt:
	terraform -chdir=./ fmt

tf-validate:
	terraform -chdir=./ validate

tf-init:
	terraform -chdir=./ init

tf-plan: tf-fmt tf-validate
	terraform -chdir=./ plan -out tf-apply.plan

tf-apply:
	terraform -chdir=./ apply tf-apply.plan

tf-destroy-plan:
	terraform -chdir=./ plan -destroy -out tf-destroy.plan

tf-destroy-apply:
	terraform -chdir=./ apply tf-destroy.plan
