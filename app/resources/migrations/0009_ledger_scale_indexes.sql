CREATE INDEX `idx_st_smith_status_created` ON `smith_transactions` (`smith_id`,`status`,`created_at`);--> statement-breakpoint
CREATE INDEX `idx_st_smith_created_id` ON `smith_transactions` (`smith_id`,`created_at`,`id`);
