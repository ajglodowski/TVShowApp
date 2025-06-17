//
//  Supabase.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 6/10/24.
//

import Supabase
import Foundation

let supabase = SupabaseClient(
    supabaseURL: URL(string: Hidden.supabaseUrl)!,
    supabaseKey: Hidden.supabaseKey
)
