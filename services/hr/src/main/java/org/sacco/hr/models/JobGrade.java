package org.sacco.hr.models;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class JobGrade {
    private Integer jobGradeId;
    private String grade;
}
