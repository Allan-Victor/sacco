package org.sacco.hr.dao;

import org.sacco.hr.dto.StaffDepartmentOrderDTO;
import org.sacco.hr.dto.StaffNextOfKinDTO;
import org.sacco.hr.dto.StaffResponseDTO;

import java.util.List;

public interface StaffDao {
    List<StaffDepartmentOrderDTO> retrieveStaffByDepartmentOrder();

    List<StaffResponseDTO> retrieveStaffDepartmentList(Integer departmentId);

    List<StaffResponseDTO> retrieveStaffPositionList(Integer jobTitleId);

    List<StaffNextOfKinDTO> retrieveStaffNextOfKin(Integer id);
}
