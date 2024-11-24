package org.sacco.hr.mapper;

import org.sacco.hr.dto.StaffDepartmentOrderDTO;
import org.sacco.hr.dto.StaffNextOfKinDTO;
import org.sacco.hr.dto.StaffResponseDTO;
import org.sacco.hr.model.*;



public class StaffDTOMapper {
    public static StaffDepartmentOrderDTO fromStaff(Staff staff){
        return new StaffDepartmentOrderDTO(
                staff.getFirstName(),
                staff.getLastName(),
                staff.getNin(),
                staff.getGender(),
                staff.getPassportPhotoUrl(),
                staff.getDateOfBirth(),
                staff.getDateOfEmployment(),
                staff.getPhoneNumber(),
                staff.getPhysicalAddress(),
                staff.getJobTitle(),
                staff.getJobGrade(),
                staff.getNatureOfEmployment(),
                staff.getDepartment(),
                staff.getQualifications(),
                staff.getNssfDetails(),
                staff.getNextOfKinDetails()
        );
    }

    public static StaffResponseDTO toStaffDepartmentResponse(Staff staff){
        return new StaffResponseDTO(
                staff.getFirstName(),
                staff.getLastName(),
                staff.getNin(),
                staff.getGender(),
                staff.getDateOfEmployment(),
                staff.getPhoneNumber(),
                staff.getPhysicalAddress(),
                staff.getJobTitle(),
                staff.getJobGrade(),
                staff.getNatureOfEmployment(),
                staff.getDepartment()
        );
    }

    public static StaffNextOfKinDTO toNextOfKinDTO(NextOfKin nextOfKin){
        return new StaffNextOfKinDTO(
                nextOfKin.getFullName(),
                nextOfKin.getStaffId(),
                nextOfKin.getRelationship(),
                nextOfKin.getPhoneNumber(),
                nextOfKin.getPhoneNumber(),
                nextOfKin.getPhysicalAddress()
        );
    }
}
