package org.sacco.hr.models;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class Department {
    private Integer departmentId;
    private String departmentName;
    private String managerName;

}
