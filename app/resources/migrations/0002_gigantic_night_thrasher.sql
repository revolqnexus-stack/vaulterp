ALTER TABLE `item_types` ADD `smith_id` integer REFERENCES smiths(id);--> statement-breakpoint
CREATE INDEX `idx_item_types_smith` ON `item_types` (`smith_id`);--> statement-breakpoint
CREATE UNIQUE INDEX `uq_item_types_smith_name` ON `item_types` (`smith_id`,`name`);