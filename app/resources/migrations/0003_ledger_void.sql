ALTER TABLE `smith_transactions` ADD `status` text DEFAULT 'active' NOT NULL;--> statement-breakpoint
ALTER TABLE `smith_transactions` ADD `voided_at` integer;--> statement-breakpoint
ALTER TABLE `smith_transactions` ADD `voided_by` integer REFERENCES users(id);--> statement-breakpoint
ALTER TABLE `smith_transactions` ADD `void_reason` text;--> statement-breakpoint
ALTER TABLE `cash_book` ADD `status` text DEFAULT 'active' NOT NULL;--> statement-breakpoint
ALTER TABLE `cash_book` ADD `voided_at` integer;--> statement-breakpoint
ALTER TABLE `cash_book` ADD `voided_by` integer REFERENCES users(id);--> statement-breakpoint
ALTER TABLE `stock_transactions` ADD `status` text DEFAULT 'active' NOT NULL;--> statement-breakpoint
ALTER TABLE `stock_transactions` ADD `voided_at` integer;--> statement-breakpoint
ALTER TABLE `stock_transactions` ADD `voided_by` integer REFERENCES users(id);
