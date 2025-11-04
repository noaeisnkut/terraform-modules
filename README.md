**trouble shootings:**
if state is locked and can't do apply:
find the blocked item in the dynamondb and delete it.
**Here are three situations where a Terraform/Terragrunt state lock is held:**

During an active apply, destroy, or import operation
Terraform acquires a lock at the start of the operation to prevent concurrent changes to the state file.
The lock is released automatically when the operation finishes successfully.
If a previous run was interrupted or failed unexpectedly
For example, if you pressed CTRL+C, your SSH session closed, or the process crashed.
The lock remains in the remote backend (like DynamoDB) until manually released.
Concurrent executions on the same state
When another user or process tries to run Terraform/Terragrunt on the same module/state at the same time.
The lock prevents multiple simultaneous writes, avoiding state corruption.
