CREATE TABLE `shadow_users` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`username` text NOT NULL,
	`display_name` text NOT NULL,
	`password_hash` text NOT NULL,
	`salt` text NOT NULL,
	`role` text DEFAULT 'employee' NOT NULL,
	`active` integer DEFAULT 1 NOT NULL,
	`failed_attempts` integer DEFAULT 0 NOT NULL,
	`lockout_until` integer,
	`created_at` integer NOT NULL,
	`created_by` integer
);
--> statement-breakpoint
CREATE UNIQUE INDEX `idx_shadow_users_username` ON `shadow_users` (`username`);--> statement-breakpoint
CREATE TABLE `shadow_pure_gold_stock` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`purity` text NOT NULL,
	`balance` real DEFAULT 0 NOT NULL,
	`last_updated` integer NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `shadow_pure_gold_stock_purity_unique` ON `shadow_pure_gold_stock` (`purity`);--> statement-breakpoint
CREATE TABLE `shadow_ornament_stock` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`item_type_id` integer NOT NULL,
	`gross_weight` real DEFAULT 0 NOT NULL,
	`net_weight` real DEFAULT 0 NOT NULL,
	`last_updated` integer NOT NULL,
	FOREIGN KEY (`item_type_id`) REFERENCES `item_types`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `shadow_ornament_stock_item_type_id_unique` ON `shadow_ornament_stock` (`item_type_id`);--> statement-breakpoint
CREATE TABLE `shadow_smith_transactions` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`type` text NOT NULL,
	`smith_id` integer NOT NULL,
	`purity` text,
	`gross_weight` real,
	`weight_995` real NOT NULL,
	`settlement_weight_995` real,
	`gold_settled_995` real,
	`cash_gold_equivalent_995` real,
	`settlement_rate_per_gram` real,
	`cash_amount` real,
	`total_gross` real,
	`total_stone_weight` real,
	`total_net` real,
	`total_stone_charge` real,
	`total_received_995` real,
	`balance_before` real NOT NULL,
	`balance_after` real NOT NULL,
	`notes` text,
	`performed_by` integer,
	`created_at` integer NOT NULL,
	`settled_for_tx_id` integer,
	FOREIGN KEY (`smith_id`) REFERENCES `smiths`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_shadow_st_smith` ON `shadow_smith_transactions` (`smith_id`);--> statement-breakpoint
CREATE INDEX `idx_shadow_st_created` ON `shadow_smith_transactions` (`created_at`);--> statement-breakpoint
CREATE TABLE `shadow_smith_transaction_items` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`transaction_id` integer NOT NULL,
	`item_type_id` integer NOT NULL,
	`gross_weight` real NOT NULL,
	`stone_weight` real DEFAULT 0 NOT NULL,
	`stone_charge` real DEFAULT 0 NOT NULL,
	`net_weight` real NOT NULL,
	`touch_percent` real NOT NULL,
	`weight_995` real NOT NULL,
	FOREIGN KEY (`transaction_id`) REFERENCES `shadow_smith_transactions`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`item_type_id`) REFERENCES `item_types`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_shadow_sti_tx` ON `shadow_smith_transaction_items` (`transaction_id`);--> statement-breakpoint
CREATE TABLE `shadow_stock_transactions` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`type` text NOT NULL,
	`purity` text,
	`item_type_id` integer,
	`weight` real NOT NULL,
	`direction` text NOT NULL,
	`notes` text,
	`performed_by` integer,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`item_type_id`) REFERENCES `item_types`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_shadow_stk_created` ON `shadow_stock_transactions` (`created_at`);--> statement-breakpoint
CREATE TABLE `shadow_cash_book` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`type` text NOT NULL,
	`amount` real NOT NULL,
	`category` text NOT NULL,
	`description` text,
	`linked_tx_id` integer,
	`linked_tx_type` text,
	`performed_by` integer,
	`created_at` integer NOT NULL
);
--> statement-breakpoint
CREATE INDEX `idx_shadow_cb_created` ON `shadow_cash_book` (`created_at`);--> statement-breakpoint
CREATE TABLE `shadow_melting_batches` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`batch_number` text NOT NULL,
	`old_gold_weight` real NOT NULL,
	`melting_loss` real DEFAULT 0 NOT NULL,
	`weight_to_sait` real,
	`analyser_purity_percent` real,
	`sait_id` integer,
	`sait_test_percent` real,
	`assay_purity_percent` real,
	`final_pure_weight` real,
	`gold_received` real DEFAULT 0 NOT NULL,
	`status` text DEFAULT 'created' NOT NULL,
	`melting_fee` real DEFAULT 0 NOT NULL,
	`created_by` integer,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`sait_id`) REFERENCES `saits`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `shadow_melting_batches_batch_number_unique` ON `shadow_melting_batches` (`batch_number`);--> statement-breakpoint
CREATE TABLE `shadow_sait_returns` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`batch_id` integer NOT NULL,
	`installment_no` integer NOT NULL,
	`weight_returned` real NOT NULL,
	`purity_returned` real,
	`melting_fee` real DEFAULT 0 NOT NULL,
	`notes` text,
	`performed_by` integer,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`batch_id`) REFERENCES `shadow_melting_batches`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_shadow_sr_batch` ON `shadow_sait_returns` (`batch_id`);
