ALTER TABLE `smith_transactions` ADD `reversal_of_tx_id` integer REFERENCES smith_transactions(id);--> statement-breakpoint
CREATE INDEX `idx_st_reversal_of` ON `smith_transactions` (`reversal_of_tx_id`);
