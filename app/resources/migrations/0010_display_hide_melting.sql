ALTER TABLE `melting_batches` ADD `display_status` text DEFAULT 'active' NOT NULL;--> statement-breakpoint
ALTER TABLE `melting_batches` ADD `hidden_at` integer;--> statement-breakpoint
ALTER TABLE `melting_batches` ADD `hidden_by` integer REFERENCES users(id);--> statement-breakpoint
ALTER TABLE `melting_batches` ADD `hide_reason` text;--> statement-breakpoint
ALTER TABLE `sait_returns` ADD `display_status` text DEFAULT 'active' NOT NULL;--> statement-breakpoint
ALTER TABLE `sait_returns` ADD `hidden_at` integer;--> statement-breakpoint
ALTER TABLE `sait_returns` ADD `hidden_by` integer REFERENCES users(id);--> statement-breakpoint
ALTER TABLE `sait_returns` ADD `hide_reason` text;
