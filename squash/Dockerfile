# LAYER 1
FROM centos

# LAYER 2
# Installed packages for building/testing/auditing purposes
RUN yum install -y skopeo ruby maven

# LAYER 3
# Remove them from final image
RUN yum remove -y skopeo ruby maven
