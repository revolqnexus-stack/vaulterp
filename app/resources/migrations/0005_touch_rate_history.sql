DROP INDEX `uq_smith_touch_rates_smith_item`;--> statement-breakpoint
ALTER TABLE `smith_touch_rates` ADD `is_default` integer DEFAULT 1 NOT NULL;--> statement-breakpoint
UPDATE `smith_touch_rates` SET `is_default` = 1;--> statement-breakpoint
CREATE INDEX `idx_touch_rates_smith_item` ON `smith_touch_rates` (`smith_id`,`item_type_id`);--> statement-breakpoint
CREATE UNIQUE INDEX `uq_smith_touch_rates_default` ON `smith_touch_rates` (`smith_id`,`item_type_id`) WHERE `is_default` = 1;
