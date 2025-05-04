import 'package:bloc/bloc.dart';
import 'package:customer/data/models/profile/customer_details_model.dart';
import 'package:customer/domain/profile/entities/customer_details_entity.dart';
import 'package:customer/domain/profile/entities/customer_details_params.dart';
import 'package:customer/domain/profile/usecases/profile_usecase.dart';
import 'package:customer/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileUseCase _profileUseCase;
  ProfileBloc({required ProfileUseCase profileUseCase})
      : _profileUseCase = profileUseCase,
        super(ProfileState()) {
    on<GetProfileEvent>(_getProfileEvent);
    on<UpdateProfileEvent>(_updateProfileEvent);
  }

  void _getProfileEvent(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _profileUseCase.getCustomerDetails();

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (customerDetails) {
        emit(
          state.copyWith(
            status: ProfileStatus.success,
            customerDetails: customerDetails,
          ),
        );
      },
    );
  }

  void _updateProfileEvent(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _profileUseCase.updateCustomerDetails(event.params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ProfileStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (customerDetails) {
        emit(
          state.copyWith(
            status: ProfileStatus.success,
          ),
        );
        ScaffoldMessenger.of(event.context!).showSnackBar(
          SnackBar(
            content: Text(customerDetails.msg),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        add(GetProfileEvent());
      },
    );
  }
}
