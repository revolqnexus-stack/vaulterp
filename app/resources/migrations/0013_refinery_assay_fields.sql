ALTER TABLE `melting_batches` ADD `assay_purity_percent` real;--> statement-breakpoint
ALTER TABLE `melting_batches` ADD `final_pure_weight` real;--> statement-breakpoint
ALTER TABLE `melting_batches` ADD `gold_received` real DEFAULT 0;
