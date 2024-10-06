import 'package:fit_pro_client/models/user.dart';
import 'package:fit_pro_client/services/account_details_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountDetailsState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;

  AccountDetailsState({
    required this.user,
    required this.isLoading,
    this.errorMessage,
  });

  factory AccountDetailsState.initial() {
    return AccountDetailsState(
      user: null,
      isLoading: false,
      errorMessage: null,
    );
  }
}

class AccountDetailsNotifier extends StateNotifier<AccountDetailsState> {
  final AccountDetailsService _accountDetailsService;

  AccountDetailsNotifier(this._accountDetailsService)
      : super(AccountDetailsState.initial());

  // Fetch user profile
  Future<void> fetchUserProfile() async {
    state = AccountDetailsState(
      user: state.user,
      isLoading: true,
    );

    try {
      final user = await _accountDetailsService.fetchUserProfile();
      state = AccountDetailsState(user: user, isLoading: false);
    } catch (e) {
      state = AccountDetailsState(
        user: null,
        isLoading: false,
        errorMessage: 'Failed to load user profile',
      );
    }
  }

  // Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> userData) async {
    state = AccountDetailsState(
      user: state.user,
      isLoading: true,
    );

    final success = await _accountDetailsService.updateUserProfile(userData);

    if (success) {
      await fetchUserProfile();
    } else {
      state = AccountDetailsState(
        user: state.user,
        isLoading: false,
        errorMessage: 'Failed to update user profile',
      );
    }
  }

  Future<void> uploadProfilePicture(dynamic image) async {
    state = AccountDetailsState(
      user: state.user,
      isLoading: true,
    );

    final profilePictureUrl = await _accountDetailsService.uploadProfilePicture(image);
 
    if (profilePictureUrl != null) {
      await updateUserProfile({'profile_picture': profilePictureUrl});
    } else {
      state = AccountDetailsState(
        user: state.user,
        isLoading: false,
        errorMessage: 'Failed to upload profile picture',
      );
    }
  }
}

final accountDetailsProvider = StateNotifierProvider<AccountDetailsNotifier, AccountDetailsState>(
  (ref) => AccountDetailsNotifier(AccountDetailsService()),
);
