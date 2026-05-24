-- Loads AnalyticsManager before PurchaseHandler connects its OnServerEvent handlers.
-- Alphabetical ordering (A < P) in ServerScriptService guarantees this.
require(script.Parent.AnalyticsManager)
-- Activate cross-server pub/sub (MessagingService subscription).
require(script.Parent.GameEventsBroadcast)
