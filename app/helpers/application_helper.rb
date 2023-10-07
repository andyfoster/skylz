require "redcarpet"

module ApplicationHelper

  # redcarpet markdown
  def markdown(text)
    text ||= "" # Handle nil values

    options = {
      filter_html: true,
      hard_wrap: true,
      link_attributes: { rel: "nofollow", target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true,
      prettify: true,
    }
    extensions = {
      autolink: true,
      superscript: true,
      disable_indented_code_blocks: true,
      tables: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      strikethrough: true,
      superscript: true,
      highlight: true,
      with_toc_data: true,
    }

    # renderer = ::Redcarpet::Render::HTML.new(options)
    renderer = TailwindStyledRenderer.new(options)

    markdown = ::Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(text).html_safe
  end

  class TailwindStyledRenderer < Redcarpet::Render::HTML

    def postprocess(full_document)
      full_document.gsub(/@(\d+)/) do
        skill_id = $1
        # skill = @current_user.skills.find_by(id: skill_id)
        skill = Skill.find_by(id: skill_id)
        if skill
          "<a href='/skills/#{skill_id}' class='text-violet-700 text-sm hover:underline bg-violet-100 p-0.5 rounded px-2'>#{skill.name}</a>"
        else
          '<span class="text-red-500">@#{skill_id}</span>'
        end
      end
    end

    def header(text, level)
      case level
      when 1
        "<div class='text-4xl mb-4'>#{text}</div>" # to not interfere with site styling - yuk
      when 2
        "<h2 class='text-3xl mb-3'>#{text}</h2>"
      when 3
        "<h3 class='text-2xl mb-2'>#{text}</h3>"
      else
        "<h#{level}>#{text}</h#{level}>"
      end
    end

    def paragraph(text)
      "<p class='mb-4'>#{text}</p>"
    end

    def block_quote(text)
      "<blockquote class='mb-4'>#{text}</blockquote>"
    end

    def list(contents, list_type)
      "<ul class='list-disc list-inside mb-4'>#{contents}</ul>"
    end

    def list_item(text, list_type)
      "<li class='mb-2'>#{text}</li>"
    end

    def table(header, body)
      "<table class='table-auto mb-4'><thead>#{header}</thead><tbody>#{body}</tbody></table>"
    end

    def table_row(content)
      "<tr>#{content}</tr>"
    end

    def table_cell(content, alignment)
      "<td class='border px-4 py-2'>#{content}</td>"
    end

    def image(link, title, alt_text)
      "<img src='#{link}' title='#{title}' alt='#{alt_text}' class='mb-4'>"
    end

    def link(link, title, content)
      "<a href='#{link}' title='#{title}' class='text-indigo-500 hover:underline'>#{content}</a>"
    end

    # if it's a @ symbol followed by a number,
    # make it a link to a skills page with that id
    # and make the text the name of that skill
    # e.g. @28 => <a href='/skills/28'>Ruby</a>
    def autolink(link, link_type)
      if link_type == :email
        "<a href='mailto:#{link}' class='text-indigo-500 hover:underline'>#{link}</a>"
      elsif link_type == :url
        "<a href='#{link}' class='text-indigo-500 hover:underline'>#{link}</a>"
      elsif link_type == :autolink
        #usage:
        # @28 => <a href='/skills/28'>Ruby</a>
        # @28, @29 => <a href='/skills/28'>Ruby</a>, <a href='/skills/29'>Rails</a>

      end
    end

    def codespan(code)
      # if first char is a $ make it non selectable
      if code[0] == "$"
        "<code class='bg-gray-200 px-1 rounded text-gray-500'>#{code}</code>"
      else
        "<code class='bg-gray-200 px-1 rounded'>#{code}</code>"
      end
    end

    def block_code(code, language)
      "<pre class='bg-gray-200 p-2 rounded'><code class='language-#{language}'>#{code}</code></pre>"
    end

    # detect if java and color nicely
    def codespan(code)
      if code.include? "public"
        "<code class='bg-gray-200 px-1 rounded text-green-500'>#{code}</code>"
      elsif code.include? "private"
        "<code class='bg-gray-200 px-1 rounded text-red-500'>#{code}</code>"
      elsif code.include? "protected"
        "<code class='bg-gray-200 px-1 rounded text-yellow-500'>#{code}</code>"
      else
        "<code class='bg-gray-200 px-1 rounded'>#{code}</code>"
      end
    end

    #make a code block that has a copy button
    def block_code(code, language)
      "<div class='relative'>
        <button class='absolute top-0 right-0 p-1 text-xs text-gray-500 hover:text-gray-900' onclick='copyToClipboard(this)'>Copy</button>
        <pre class='bg-gray-200 p-2 rounded'><code class='language-#{language}'>#{code}</code></pre>
      </div>"
    end

    private

    # def current_user
    #   @current_user ||= User.find_by(id: session[:user_id])
    # end

    # Add more methods as needed to style other Markdown elements.
  end
end
