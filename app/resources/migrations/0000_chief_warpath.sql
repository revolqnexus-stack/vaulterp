CREATE TABLE `system_config` (
	`key` text PRIMARY KEY NOT NULL,
	`value` text NOT NULL,
	`locked` integer DEFAULT 0 NOT NULL,
	`updated_at` integer
);
--> statement-breakpoint
CREATE TABLE `users` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`username` text NOT NULL,
	`display_name` text NOT NULL,
	`password_hash` text NOT NULL,
	`salt` text NOT NULL,
	`role` text NOT NULL,
	`active` integer DEFAULT 1 NOT NULL,
	`failed_attempts` integer DEFAULT 0 NOT NULL,
	`lockout_until` integer,
	`created_at` integer NOT NULL,
	`created_by` integer,
	FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `users_username_unique` ON `users` (`username`);--> statement-breakpoint
CREATE INDEX `idx_users_username` ON `users` (`username`);--> statement-breakpoint
CREATE TABLE `item_types` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`name` text NOT NULL,
	`hsn_code` text,
	`active` integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE TABLE `purity_master` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`purity` text NOT NULL,
	`conversion_factor` real NOT NULL,
	`is_active` integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `purity_master_purity_unique` ON `purity_master` (`purity`);--> statement-breakpoint
CREATE TABLE `saits` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`name` text NOT NULL,
	`number` text,
	`notes` text,
	`active` integer DEFAULT 1 NOT NULL,
	`created_at` integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE `smith_touch_rates` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`smith_id` integer NOT NULL,
	`item_type_id` integer NOT NULL,
	`touch_percent` real NOT NULL,
	`updated_at` integer NOT NULL,
	`updated_by` integer,
	FOREIGN KEY (`smith_id`) REFERENCES `smiths`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`item_type_id`) REFERENCES `item_types`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`updated_by`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `uq_smith_touch_rates_smith_item` ON `smith_touch_rates` (`smith_id`,`item_type_id`);--> statement-breakpoint
CREATE TABLE `smiths` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`name` text NOT NULL,
	`number` text,
	`notes` text,
	`active` integer DEFAULT 1 NOT NULL,
	`created_at` integer NOT NULL
);
--> statement-breakpoint
CREATE INDEX `idx_smiths_active` ON `smiths` (`active`);--> statement-breakpoint
CREATE TABLE `smith_transaction_items` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`transaction_id` integer NOT NULL,
	`item_type_id` integer NOT NULL,
	`gross_weight` real NOT NULL,
	`stone_weight` real DEFAULT 0 NOT NULL,
	`stone_charge` real DEFAULT 0 NOT NULL,
	`net_weight` real NOT NULL,
	`touch_percent` real NOT NULL,
	`weight_995` real NOT NULL,
	FOREIGN KEY (`transaction_id`) REFERENCES `smith_transactions`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`item_type_id`) REFERENCES `item_types`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_sti_tx` ON `smith_transaction_items` (`transaction_id`);--> statement-breakpoint
CREATE TABLE `smith_transactions` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`type` text NOT NULL,
	`smith_id` integer NOT NULL,
	`purity` text,
	`gross_weight` real,
	`weight_995` real NOT NULL,
	`settlement_weight_995` real,
	`cash_amount` real,
	`total_gross` real,
	`total_stone_weight` real,
	`total_net` real,
	`total_stone_charge` real,
	`total_received_995` real,
	`balance_before` real NOT NULL,
	`balance_after` real NOT NULL,
	`notes` text,
	`performed_by` integer NOT NULL,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`smith_id`) REFERENCES `smiths`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`performed_by`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_st_smith` ON `smith_transactions` (`smith_id`);--> statement-breakpoint
CREATE INDEX `idx_st_type` ON `smith_transactions` (`type`);--> statement-breakpoint
CREATE INDEX `idx_st_created` ON `smith_transactions` (`created_at`);--> statement-breakpoint
CREATE TABLE `melting_batches` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`batch_number` text NOT NULL,
	`old_gold_weight` real NOT NULL,
	`melting_loss` real DEFAULT 0 NOT NULL,
	`acid_weight` real,
	`test_piece_weight` real DEFAULT 0 NOT NULL,
	`weight_to_sait` real,
	`analyser_purity_percent` real,
	`shop_pure_weight` real,
	`sait_id` integer,
	`sait_test_percent` real,
	`sait_pure_weight` real,
	`gap_percent` real,
	`gap_flag` integer DEFAULT 0 NOT NULL,
	`status` text DEFAULT 'created' NOT NULL,
	`test_piece_disposed` integer DEFAULT 0 NOT NULL,
	`disposal_notes` text,
	`melting_fee` real DEFAULT 0 NOT NULL,
	`created_by` integer,
	`created_at` integer NOT NULL,
	`closed_at` integer,
	FOREIGN KEY (`sait_id`) REFERENCES `saits`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `melting_batches_batch_number_unique` ON `melting_batches` (`batch_number`);--> statement-breakpoint
CREATE INDEX `idx_mb_sait` ON `melting_batches` (`sait_id`);--> statement-breakpoint
CREATE INDEX `idx_mb_status` ON `melting_batches` (`status`);--> statement-breakpoint
CREATE TABLE `sait_returns` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`batch_id` integer NOT NULL,
	`installment_no` integer NOT NULL,
	`weight_returned` real NOT NULL,
	`purity_returned` real,
	`melting_fee` real DEFAULT 0 NOT NULL,
	`notes` text,
	`performed_by` integer,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`batch_id`) REFERENCES `melting_batches`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`performed_by`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_sr_batch` ON `sait_returns` (`batch_id`);--> statement-breakpoint
CREATE TABLE `ornament_stock` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`item_type_id` integer NOT NULL,
	`gross_weight` real DEFAULT 0 NOT NULL,
	`net_weight` real DEFAULT 0 NOT NULL,
	`last_updated` integer NOT NULL,
	FOREIGN KEY (`item_type_id`) REFERENCES `item_types`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `ornament_stock_item_type_id_unique` ON `ornament_stock` (`item_type_id`);--> statement-breakpoint
CREATE TABLE `pure_gold_stock` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`purity` text NOT NULL,
	`balance` real DEFAULT 0 NOT NULL,
	`last_updated` integer NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `pure_gold_stock_purity_unique` ON `pure_gold_stock` (`purity`);--> statement-breakpoint
CREATE TABLE `stock_transactions` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`type` text NOT NULL,
	`purity` text,
	`item_type_id` integer,
	`weight` real NOT NULL,
	`direction` text NOT NULL,
	`notes` text,
	`performed_by` integer,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`item_type_id`) REFERENCES `item_types`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`performed_by`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_stk_type` ON `stock_transactions` (`type`);--> statement-breakpoint
CREATE INDEX `idx_stk_created` ON `stock_transactions` (`created_at`);--> statement-breakpoint
CREATE TABLE `cash_book` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`type` text NOT NULL,
	`amount` real NOT NULL,
	`category` text NOT NULL,
	`description` text,
	`linked_tx_id` integer,
	`linked_tx_type` text,
	`performed_by` integer,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`performed_by`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_cb_category` ON `cash_book` (`category`);--> statement-breakpoint
CREATE INDEX `idx_cb_created` ON `cash_book` (`created_at`);--> statement-breakpoint
CREATE TABLE `backup_log` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`backup_path` text NOT NULL,
	`size_bytes` integer,
	`file_hash` text,
	`status` text NOT NULL,
	`performed_by` integer,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`performed_by`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `change_requests` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`request_type` text NOT NULL,
	`module` text NOT NULL,
	`ref_id` integer,
	`ref_type` text,
	`description` text NOT NULL,
	`proposed_data` text,
	`old_data` text,
	`new_data` text,
	`status` text DEFAULT 'pending' NOT NULL,
	`submitted_by` integer NOT NULL,
	`reviewed_by` integer,
	`review_notes` text,
	`created_at` integer NOT NULL,
	`reviewed_at` integer,
	FOREIGN KEY (`submitted_by`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`reviewed_by`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_cr_status` ON `change_requests` (`status`);--> statement-breakpoint
CREATE INDEX `idx_cr_ref` ON `change_requests` (`ref_type`,`ref_id`);--> statement-breakpoint
CREATE TABLE `opening_balances` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`smith_id` integer NOT NULL,
	`balance_995` real NOT NULL,
	`locked` integer DEFAULT 1 NOT NULL,
	`created_at` integer NOT NULL,
	`created_by` integer,
	FOREIGN KEY (`smith_id`) REFERENCES `smiths`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `opening_balances_smith_id_unique` ON `opening_balances` (`smith_id`);--> statement-breakpoint
CREATE TABLE `audit_log` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`action` text NOT NULL,
	`module` text NOT NULL,
	`ref_id` integer,
	`ref_type` text,
	`old_data` text,
	`new_data` text,
	`change_request_id` integer,
	`performed_by` integer,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`change_request_id`) REFERENCES `change_requests`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`performed_by`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_al_module` ON `audit_log` (`module`);--> statement-breakpoint
CREATE INDEX `idx_al_created` ON `audit_log` (`created_at`);--> statement-breakpoint
CREATE INDEX `idx_al_ref` ON `audit_log` (`ref_type`,`ref_id`);