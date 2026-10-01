ALTER TABLE `smith_transactions` ADD `settled_for_tx_id` integer REFERENCES smith_transactions(id);--> statement-breakpoint
CREATE INDEX `idx_st_settled_for` ON `smith_transactions` (`settled_for_tx_id`);
