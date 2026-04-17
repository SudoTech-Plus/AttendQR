import Foundation
import Supabase

/// A singleton manager to handle the Supabase client lifecycle.
class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        // Ensure secrets are configured before initializing
        guard SupabaseConfig.isConfigured else {
            fatalError("Supabase is not configured. Please check Secrets.plist")
        }
        
        self.client = SupabaseClient(
            supabaseURL: URL(string: SupabaseConfig.url)!,
            supabaseKey: SupabaseConfig.anonKey
        )
    }
}
