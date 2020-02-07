-- BLOCK select_course_users
SELECT
    u.user_id,
    u.uid,
    u.name,
    cp.course_role,
    jsonb_agg(jsonb_build_object(
        'id', ci.id,
        'short_name', ci.short_name,
        'course_instance_permission_id', cip.id,
        'course_instance_role', cip.course_instance_role
    ) ORDER BY d.start_date DESC NULLS LAST, d.end_date DESC NULLS LAST, ci.id DESC) FILTER (WHERE cip.course_instance_role IS NOT NULL) AS course_instance_roles
FROM
    course_permissions AS cp
    JOIN users AS u ON (u.user_id = cp.user_id)
    LEFT JOIN course_instance_permissions AS cip ON (cip.course_permission_id = cp.id)
    LEFT JOIN course_instances AS ci ON (ci.id = cip.course_instance_id AND ci.course_id = $course_id),
    LATERAL (SELECT min(ar.start_date) AS start_date, max(ar.end_date) AS end_date FROM course_instance_access_rules AS ar WHERE ar.course_instance_id = ci.id) AS d
WHERE
    cp.course_id = $course_id
GROUP BY
    u.user_id, cp.course_role;

-- BLOCK update_course_permissions
UPDATE course_permissions AS cp
SET
    course_role = $course_role
WHERE
    cp.user_id = $user_id
    AND cp.course_id = $course_id;
