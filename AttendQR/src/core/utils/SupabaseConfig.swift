import Foundation

/// A utility to manage and access Supabase configuration secrets.
/// This reads from `Secrets.plist` to keep sensitive keys out of the source code.
enum SupabaseConfig {
    
    private static var secrets: [String: Any]? {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            print("⚠️ SupabaseConfig: Secrets.plist not found or invalid format.")
            return nil
        }
        return dict
    }
    
    /// The Supabase Project URL
    static var url: String {
        guard let urlString = secrets?["SUPABASE_URL"] as? String, !urlString.isEmpty else {
            print("❌ SupabaseConfig: SUPABASE_URL is missing in Secrets.plist")
            return ""
        }
        return urlString
    }
    
    /// The Supabase Anon/Public Key
    static var anonKey: String {
        guard let key = secrets?["SUPABASE_ANON_KEY"] as? String, !key.isEmpty else {
            print("❌ SupabaseConfig: SUPABASE_ANON_KEY is missing in Secrets.plist")
            return ""
        }
        return key
    }

    /// The Supabase Service Role Key
    static var serviceRoleKey: String {
        guard let key = secrets?["SUPABASE_SERVICE_ROLE_KEY"] as? String, !key.isEmpty else {
            print("❌ SupabaseConfig: SUPABASE_SERVICE_ROLE_KEY is missing in Secrets.plist")
            return ""
        }
        return key
    }
    
    /// Validation helper to check if secrets are properly configured
    static var isConfigured: Bool {
        return !url.isEmpty && !anonKey.isEmpty && url != "https://your-project-id.supabase.co"
    }
}
