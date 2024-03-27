# mailer

class ProjectMailer < ApplicationMailer
    def invite_member()
        project_member = params[:project_member]
        @project_name = project_member.project.name
        @member_email = project_member.user_email
        mail(to: @member_email, subject: "Bem-vindo(a) ao projeto #{@project_name}!")
    end 
end